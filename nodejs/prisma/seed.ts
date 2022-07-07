import { PrismaClient, Prisma, PasswdHashType } from '@prisma/client'
import argon2 from 'argon2';

const prisma = new PrismaClient()


const roleData: Prisma.RoleCreateInput[] = [
  {
    roleName: 'System Admin',
    roleType: 'sys_admin',
    roleLevel: 1000,
    isActive: true,
  },
  {
    roleName: 'Admin',
    roleType: 'admin',
    roleLevel: 900,
    isActive: true,
  },
  {
    roleName: 'Moderator',
    roleType: 'moderator',
    roleLevel: 600,
    isActive: true,
  },
  {
    roleName: 'Data Entry',
    roleType: 'data_entry',
    roleLevel: 400,
    isActive: true,
  },
  {
    roleName: 'Regular User',
    roleType: 'regular',
    roleLevel: 200,
    isActive: true,
  }
];


const systemUser: Prisma.UserAccountsCreateInput = {
  userName: 'system',
  firstName: 'System',
  role: {
    connect: {
      roleType: 'sys_admin'
    }
  },
};

const systemCreatedUsers: Prisma.UserAccountsCreateInput[] = [
  {
    userName: 'system-manager',
    firstName: 'System-manager',
    role: {
      connect: {
        roleType: 'sys_admin'
      }
    },
    creator: {
      connect: {
        userName: 'system',
      }
    },
  },
  {
    userName: 'alok',
    firstName: 'Alok',
    role: {
      connect: {
        roleType: 'admin'
      }
    },
    creator: {
      connect: {
        userName: 'system',
      }
    },
  },
  {
    userName: 'mushaheed',
    firstName: 'Mushaheed',
    lastName: 'Syed',
    role: {
      connect: {
        roleType: 'admin'
      }
    },
    creator: {
      connect: {
        userName: 'system',
      }
    },
  },
];

const userPasswdData = (pwd: string): Prisma.UserCredentialsCreateInput[] => [
  {
    hashType: PasswdHashType.ARGON2,
    passwordHash: pwd,
    user: {
      connect: {
        userName: 'system-manager'
      }
    }
  },
  {
    hashType: PasswdHashType.NONE,
    user: {
      connect: {
        userName: 'mushaheed'
      }
    }
  },
  {
    hashType: PasswdHashType.NONE,
    user: {
      connect: {
        userName: 'alok'
      }
    }
  }
];

async function main() {
  console.log(`Start seeding ...`);

  for (const r of roleData) {
    const response = await prisma.role.create({
      data: r,
    });
    console.log(`Created role with id: ${response.id}`)
  }

  const response = await prisma.userAccounts.create({
    data: systemUser,
  });
  console.log(`Created system user with id: ${response.id}`)

  for (const user of systemCreatedUsers) {
    const response = await prisma.userAccounts.create({
      data: user
    });
    console.log(`Created user with id: ${response.id}`)
  }

  const _pwd = await argon2.hash('win-----10100101');
  const userPasswd = userPasswdData(_pwd);

  for (const p of userPasswd) {
    const response = await prisma.userCredentials.create({
      data: p,
    })
    console.log(`Created passwd with id: ${response.id}`)
  }

  console.log(`Seeding finished.`)
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })