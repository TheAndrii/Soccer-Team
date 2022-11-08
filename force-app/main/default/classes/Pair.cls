public with sharing class Pair {
    public Integer value { get; set; }
    public String key { get; set; }
    
    public Pair(Integer value, String key) {
        this.value = value;
        this.key = key;
    }
}
