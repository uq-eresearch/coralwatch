package org.coralwatch.util;

import java.util.LinkedHashMap;
import java.util.Map;

public class M {

  public static <K,V> Map<K,V> of(K k1, V v1) {
    Map<K,V> m = new LinkedHashMap<K,V>();
    m.put(k1, v1);
    return m;
  }

  public static <K,V> Map<K,V> of(K k1, V v1, K k2, V v2) {
    Map<K,V> m = of(k1, v1);
    m.put(k2, v2);
    return m;
  }

  public static <K,V> Map<K,V> of(K k1, V v1, K k2, V v2, K k3, V v3) {
    Map<K,V> m = of(k1, v1, k2, v2);
    m.put(k3, v3);
    return m;
  }

  public static <K,V> Map<K,V> of(K k1, V v1, K k2, V v2, K k3, V v3, K k4, V v4) {
    Map<K,V> m = of(k1, v1, k2, v2, k3, v3);
    m.put(k4, v4);
    return m;
  }

  public static <K,V> Map<K,V> of(K k1, V v1, K k2, V v2, K k3, V v3, K k4, V v4, K k5, V v5) {
    Map<K,V> m = of(k1, v1, k2, v2, k3, v3, k4, v4);
    m.put(k5, v5);
    return m;
  }

  public static <K,V> Map<K,V> of(K k1, V v1, K k2, V v2, K k3, V v3,
      K k4, V v4, K k5, V v5, K k6, V v6) {
    Map<K,V> m = of(k1, v1, k2, v2, k3, v3, k4, v4, k5, v5);
    m.put(k6, v6);
    return m;
  }

  public static <K,V> Map<K,V> of(K k1, V v1, K k2, V v2, K k3, V v3,
      K k4, V v4, K k5, V v5, K k6, V v6, K k7, V v7) {
    Map<K,V> m = of(k1, v1, k2, v2, k3, v3, k4, v4, k5, v5, k6, v6);
    m.put(k7, v7);
    return m;
  }

  public static <K,V> Map<K,V> of(K k1, V v1, K k2, V v2, K k3, V v3,
      K k4, V v4, K k5, V v5, K k6, V v6, K k7, V v7, K k8, V v8) {
    Map<K,V> m = of(k1, v1, k2, v2, k3, v3, k4, v4, k5, v5, k6, v6, k7, v7);
    m.put(k8, v8);
    return m;
  }

  @SafeVarargs
  public static <K, V> Map<K,V> copyOf(Map<K,V> map, K... keys) {
    Map<K,V> m = new LinkedHashMap<K,V>();
    for(K key : keys) {
      m.put(key, map.get(key));
    }
    return m;
  }

}
