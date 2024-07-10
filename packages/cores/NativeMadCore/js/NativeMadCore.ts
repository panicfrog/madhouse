import type { TurboModule } from 'react-native/Libraries/TurboModule/RCTExport';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  appStartAt(): number;
}

export default TurboModuleRegistry.getEnforcing<Spec>('NativeMadCore') as Spec;
