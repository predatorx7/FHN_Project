import prismaService from '../../../common/services/prisma.service';
import debug from 'debug';
import { CreateUserDto } from '../dto/create.user.dto';
import { PatchUserDto } from '../dto/patch.user.dto';
import { PutUserDto } from '../dto/put.user.dto';
import { PasswdHashType, Prisma, Role, UserAccounts } from '@prisma/client';
import { UserDtoWithPassword } from '../dto/user.dto';

const log: debug.IDebugger = debug('app:users-dao');

class UsersDao {
    _prisma = prismaService.prisma;

    get userAccounts() { return this._prisma.userAccounts; }
    get userCredentials() { return this._prisma.userCredentials; }
    get userRoles() { return this._prisma.role; }

    constructor() {
        log('Created new instance of UsersDao');
    }

    async addUser(userFields: CreateUserDto) {
        log('Adding user');
        log(userFields);
        const user = await this.userAccounts.create({
            data: {
                userName: userFields.username,
                email: userFields.email,
                firstName: userFields.firstname,
                lastName: userFields.lastname,
                role: {
                    connect: {
                        roleType: 'regular'
                    }
                },
                passwords: {
                    create: {
                        passwordHash: userFields.password,
                        passwordSalt: null,
                        hashType: PasswdHashType.ARGON2,
                    }
                },
                creator: {
                    connect: userFields._user,
                },
            },
        });
        return user.id;
    }


    async getUserByUsername(username: string): Promise<UserAccounts | null> {
        log('Getting getUserByUsername');
        return this.userAccounts.findUnique<Prisma.UserAccountsFindUniqueArgs, undefined>({
            where: {
                userName: username,
            }
        });
    }

    async getUserByUsernameWithPassword(username: string): Promise<UserDtoWithPassword | null> {
        log('Getting getUserByUsernameWithPassword');
        const user = await this.userAccounts.findUnique<Prisma.UserAccountsFindUniqueArgs, undefined>({
            select: {
                id: true,
                email: true,
                userName: true,
                firstName: true,
                lastName: true,
                roleId: true,
            },
            where: {
                userName: username,
            }
        });

        log(`Fetched user with username: ${username}`);
        log(user);

        if (!user) return null;

        const passwd = await this.userCredentials.findUnique<Prisma.UserCredentialsFindUniqueArgs, undefined>({
            where: {
                userName: username,
            }
        })

        if (!user.roleId || isNaN(user.roleId)) {
            return null;
        }

        log(`Fetching role for roleId: ${user.roleId}`);

        const role = await this.userRoles.findFirst({
            where: {
                id: user.roleId,
            }
        });

        log(`Received role= roleLevel: ${role?.roleLevel}, roleName: ${role?.roleType}`);

        return {
            id: user.id,
            username: user.userName,
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            passwordHash: passwd?.passwordHash || '',
            passwordType: passwd?.hashType || null,
            roleType: role?.roleType || 'unknown',
            roleLevel: role?.roleLevel || 1,
        }
    }

    async removeUserById(userId: number) {
        return this.userAccounts.delete({
            where: {
                id: userId,
            }
        })
    }

    async getUserById(userId: number) {
        log('Getting user by id');
        return this.userAccounts.findUnique({ where: { id: userId } })
    }

    async getUsers(limit = 25, page = 0) : Promise<UserAccounts[]> {
        return this.userAccounts.findMany<Prisma.UserAccountsFindManyArgs>({
            skip: limit * page,
            take: limit,
            where: {
                userName: {
                    notIn: ['system', 'system-manager',],
                }
            }
        });
    }

    async getRoles(limit = 25, page = 0) : Promise<Role[]> {
        return this.userRoles.findMany({
            skip: limit * page,
            take: limit,
        });
    }

    async updateUserById(
        userId: number,
        userFields: PatchUserDto | PutUserDto
    ) {
        const user = await this.userAccounts.update<Prisma.UserAccountsUpdateArgs>(
            {
                data: {
                    userName: userFields.username,
                    firstName: userFields.firstName,
                    lastName: userFields.lastName,
                    email: userFields.email,
                    role: userFields.roleType ? {
                        connect: {
                            roleType: userFields.roleType,
                        }
                    } : undefined,
                    passwords: userFields.password ? {
                        update: {
                            data: {
                                passwordHash: userFields.password,
                                hashType: PasswdHashType.ARGON2,
                            },
                            where: {
                                userName: userFields.username,
                            }
                        }
                    } : undefined,
                },
                where: {
                    id: userId,
                }
            }
        );
        return user;
    }
}

export default new UsersDao();
