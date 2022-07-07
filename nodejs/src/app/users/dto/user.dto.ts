import { PasswdHashType } from "@prisma/client"

export interface AddUserDto {
    username: string
    firstname?: string
    lastname?: string
    roleType: string
    credentials: UserAccountCredentials
}

export type UserAccountData = {
    id: number
    email: string | null
    userName: string
    firstName: string | null
    lastName: string | null
    roleId: number
    creatorId: number | null
    createdAt: Date
}

export type UserAccountCredentials = {
    hash: string | null,
    salt: string | null,
    hashType: PasswdHashType,
}

export interface UserDto {
    id: number;
    roleType: string;
    roleLevel: number;
    username: string;
    email?: string | null;
    password?: string;
    firstName?: string | null;
    lastName?: string | null;
}

export interface UserDtoWithPassword extends UserDto {
    passwordHash: string;
    passwordType: PasswdHashType | null;
}
