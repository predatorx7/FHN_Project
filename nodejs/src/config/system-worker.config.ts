export interface SystemWorkerConfig {
  systemServerUrl: string;
  get runSystemInterval(): number;
}

class SystemWorkerConfigImpl implements SystemWorkerConfig {
  systemServerUrl = 'http://localhost:3000';

  get runSystemInterval(): number {
    // 10 minutes
    return 10 * 60 * 1000;
  }
}

export const systemWorkerConfig: SystemWorkerConfig = new SystemWorkerConfigImpl();
