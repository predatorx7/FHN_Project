import { Prisma } from "@prisma/client";
import { JwtId } from "../../../common/types/jwt";

export interface CreateUserDto {
    username: string;
    email?: string | null;
    password: string;
    firstname?: string | null;
    lastname?: string | null;
    _user: JwtId,
}
