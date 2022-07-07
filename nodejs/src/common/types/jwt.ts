import { UserDtoWithPassword } from "../../app/users/dto/user.dto";

export type Jwt = {
    userId: number;
    username: string;
    provider: string;
    roleType: string;
    roleLevel: number;
    refreshKey: string | Buffer | null;
};

export type JwtId = {
    id: number;
};

export const fromUserDtoWithPassword = (data: UserDtoWithPassword): Jwt => {
    return {
        userId: data.id,
        username: data.username,
        provider: 'username',
        roleType: data.roleType,
        roleLevel: data.roleLevel,
        refreshKey: '',
    }
}
