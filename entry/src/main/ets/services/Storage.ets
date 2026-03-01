import preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';

export interface Storage {
  init(context: common.Context): Promise<void>;

  get(key: string): Promise<string | undefined>;

  set(key: string, value: string): Promise<void>;
}

export class StorageImpl implements Storage {
  private prefs: preferences.Preferences | null = null;

  async init(context: common.Context): Promise<void> {
    this.prefs = await preferences.getPreferences(context, 'flowear');
  }

  async get(key: string): Promise<string | undefined> {
    if (!this.prefs) {
      console.error('[STORAGE] prefs NOT initialized');
      return undefined;
    }
    const v = await this.prefs.get(key, '') as string;
    console.info('[STORAGE] get', key, v);
    return v;
  }

  async set(key: string, value: string): Promise<void> {
    if (!this.prefs) {
      console.error('[STORAGE] prefs NOT initialized');
      return;
    }
    console.info('[STORAGE] set', key, value);
    await this.prefs.put(key, value);
    await this.prefs.flush();
  }

  has(key: string): boolean | undefined {
    if (!this.prefs) {
      console.error('[STORAGE] prefs NOT initialized');
      return false;
    }
    const v = this.prefs.hasSync(key);
    console.info('[STORAGE] has', key, v);
    return v;
  }
}

export const storage = new StorageImpl();