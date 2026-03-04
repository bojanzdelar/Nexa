export interface Person {
  id: number;
  name: string;
  profilePath: string;
}

export interface Cast extends Person {
  character: string;
}

export interface Crew extends Person {
  job: string;
}
