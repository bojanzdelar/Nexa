export interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
}

export interface UserLoginRequest {
  email: string;
  password: string;
}

export interface UserRegisterRequest extends UserLoginRequest {
  firstName: string;
  lastName: string;
}

export type ConfirmEmailRequest = {
  email: string;
  code: string;
};

export type ResendConfirmationCodeRequest = {
  email: string;
};
