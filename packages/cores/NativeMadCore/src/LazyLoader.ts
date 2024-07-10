type Loader<T> = () => T;

function createLazyProxy<T extends object>(loader: Loader<T>): T {
  let instance: T | null = null;

  const handler: ProxyHandler<Loader<T>> = {
    get(target, prop, receiver) {
      if (instance === null) {
        instance = target();
      }
      return Reflect.get(instance, prop, receiver);
    },
    apply(target, thisArg, argumentsList) {
      if (instance === null) {
        instance = target();
      }
      return Reflect.apply(instance as any, thisArg, argumentsList);
    },
  };

  return new Proxy(loader, handler) as unknown as T;
}

export default createLazyProxy;
