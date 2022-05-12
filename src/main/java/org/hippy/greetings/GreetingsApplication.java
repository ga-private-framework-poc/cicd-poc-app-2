package org.hippy.greetings;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.concurrent.TimeUnit;

import org.apache.commons.lang3.StringUtils;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Profile;

@Profile("!test")
@SpringBootApplication
public class GreetingsApplication implements CommandLineRunner {

    @Value("${message.welcome}")
    private String welcomeMsg;

    @Value("${message.file}")
    private String welcomeMsgFilePath;

    @Override
    public void run(String... args) throws Exception {
        while (true) {
            String msg = welcomeMsg;
            
            if (!StringUtils.isBlank(welcomeMsgFilePath)) {
                File welcomeMsgFile = new File (welcomeMsgFilePath);
                if (welcomeMsgFile.exists()) {
                    try (BufferedReader br = new BufferedReader(new FileReader(welcomeMsgFile))) {
                        msg = br.readLine();
                    }
                }
                else {
                    System.out.println("ERROR: File not found: " + welcomeMsgFilePath);
                }
            }
            
            System.out.println("GREETING: " + msg);

            TimeUnit.SECONDS.sleep(3);
        }
    }

    public static void main(String[] args) {
        SpringApplication.run(GreetingsApplication.class, args);
    }
}
