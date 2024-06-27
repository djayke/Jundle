package io.jzk;


import com.google.gson.Gson;

public class Main {
    public static void main(String[] args) {
        Gson gson = new Gson();

// POJO -> JSON String
        Employee a = new Employee();
        a.id = 1;
        a.firstName = "a";
        a.lastName = "x";
        String json = gson.toJson(a);

// JSON String -> POJO
        Employee user = gson.fromJson(json, Employee.class);

        System.out.println(user.firstName);
    }
}