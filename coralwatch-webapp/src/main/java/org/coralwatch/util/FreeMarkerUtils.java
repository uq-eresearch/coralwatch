package org.coralwatch.util;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

public class FreeMarkerUtils {
    // FreeMarker can only handle Map<String, ?> so we need to convert anything else.
    public static <K, V> SortedMap<String, V> toSortedFreemarkerHash(Map<K, V> map) {
        SortedMap<String, V> result = new TreeMap<String, V>();
        for (K key : map.keySet()) {
            result.put(String.valueOf(key), map.get(key));
        }
        return result;
    }

    public static <K, V> Map<String, V> toFreemarkerHash(Map<K, V> map) {
        Map<String, V> result = new LinkedHashMap<String, V>();
        for (K key : map.keySet()) {
            result.put(String.valueOf(key), map.get(key));
        }
        return result;
    }
}
