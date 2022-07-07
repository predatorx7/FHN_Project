import UsersDao from '../daos/users.dao';
import { CRUD } from '../../../common/interfaces/crud.interface';
import { CreateUserDto } from '../dto/create.user.dto';
import { PutUserDto } from '../dto/put.user.dto';
import { PatchUserDto } from '../dto/patch.user.dto';
import { UserDtoWithPassword } from '../dto/user.dto';
import { Role, UserAccounts } from '@prisma/client';

class UsersService implements CRUD {
    async create(resource: CreateUserDto) {
        return UsersDao.addUser(resource);
    }

    async deleteById(id: number) {
        const ac = UsersDao.removeUserById(id);
        return ac != null ? '' : ''
    }

    async list(limit: number, page: number): Promise<UserAccounts[]> {
        return UsersDao.getUsers(limit, page);
    }

    async listRoles(limit: number, page: number): Promise<Role[]> {
        return UsersDao.getRoles(limit, page);
    }

    async patchById(id: number, resource: PatchUserDto): Promise<any> {
        return UsersDao.updateUserById(id, resource);
    }

    async putById(id: number, resource: PutUserDto): Promise<any> {
        return UsersDao.updateUserById(id, resource);
    }

    async readById(id: number) {
        return UsersDao.getUserById(id);
    }

    async updateById(id: number, resource: PatchUserDto | PutUserDto): Promise<any> {
        return UsersDao.updateUserById(id, resource);
    }

    async getUserByUsername(email: string) {
        return UsersDao.getUserByUsername(email);
    }
    async getUserByUsernameWithPassword(email: string): Promise<UserDtoWithPassword | null> {
        return UsersDao.getUserByUsernameWithPassword(email);
    }
}

export default new UsersService();
