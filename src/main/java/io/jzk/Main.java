package io.jzk;


import com.google.gson.Gson;

public class Main {
    public static void main(String[] args) {
        Gson gson = new Gson();

// POJO -> JSON String
        Employee a = new Employee();
        a.id = 1;
        a.firstName = "Username";
        a.lastName = "domain";
        String json = gson.toJson(a);

// JSON String -> POJO
        Employee user = gson.fromJson(json, Employee.class);

        System.out.println(user.firstName);
        System.out.println(user.lastName);
        System.out.println("using myvery own bash full build system and binding dependencies from maven central, just a cd away from it earlier!");
    }
}