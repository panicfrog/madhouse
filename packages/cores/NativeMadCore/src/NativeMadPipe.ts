import type { TurboModule } from 'react-native/Libraries/TurboModule/RCTExport';
import { TurboModuleRegistry } from 'react-native';
import LazyLoader from './LazyLoader';

export interface Spec extends TurboModule {
  pipe(action: string, input: Uint8Array | null): Uint8Array | null;
}

// export default TurboModuleRegistry.getEnforcing<Spec>('NativeMadCore') as Spec;
export default LazyLoader(() => TurboModuleRegistry.getEnforcing<Spec>('NativeMadPipe') as Spec);
