// App.tsx
import React from 'react';
import {StyleSheet, View} from 'react-native';
import {NativeModules} from 'react-native';
import {MadButton} from '@madhouse/buttons';
import {native, nativePipe} from 'NativeMadCore';
import {MsgPackDecoderFast} from '@jsonjoy.com/json-pack/lib/msgpack';

const App: React.FC = () => {
  return (
    <View style={styles.container}>
      <MadButton
        title="Simple Native Module"
        onPress={() => {
          // @ts-ignore
          let start = performance.now();
          NativeModules.SimpleNativeModule.sampleMethod().then((result: number) => {
            console.log(`origin: rn start with: ${((global.rnstart as number) / 1000 - result).toFixed(3)} s`);
            let fn_exec_end = performance.now();
            console.log(`origin: js exec time: ${(fn_exec_end - start).toFixed(3)} ms`);
            console.log('\n');
          });
        }}
      />
      <View style={styles.space} />
      <MadButton
        title="Turbo Native Module"
        onPress={() => {
          if (native === null) {
            return;
          }
          // @ts-ignore
          let start = performance.now();
          let appStart = native.appStartAt();
          let fn_exec_end = performance.now();
          console.log(`turbo: rn start with: result: ${(global.rnstart / 1000 - appStart).toFixed(3)} s`);
          // @ts-ignore
          console.log(`turbo: js exec time: ${(fn_exec_end - start).toFixed(3)} ms`);
          console.log('\n');
        }}
      />
      <View style={styles.space} />
      <MadButton
        title="get current user"
        onPress={() => {
          let start = performance.now();
          let actionName = 'getCurrentUser';
          let result = nativePipe.pipe(actionName, null);
          if (result instanceof Uint8Array) {
            const decoder = new MsgPackDecoderFast();
            const decoded = decoder.decode(result);
            let fn_exec_end = performance.now();
            console.log(
              `turbo:\n     call action: \n     name:${actionName} \n     getValue: ${JSON.stringify(
                decoded,
              )}\n     with time: ${(fn_exec_end - start).toFixed(3)} ms`,
            );
            console.log('\n');
          } else {
            console.log('is not Uint8Array');
          }
        }}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#f5fcff',
  },
  space: {
    height: 10,
  },
});

export default App;
