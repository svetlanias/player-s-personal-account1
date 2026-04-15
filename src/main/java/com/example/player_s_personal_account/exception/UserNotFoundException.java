package com.example.player_s_personal_account.exception;

public class UserNotFoundException extends RuntimeException {
    public UserNotFoundException() {
      super("User not found");
    }
  public UserNotFoundException(Long id) {
    super("User with id " + id + " not found");
  }
}
