export interface Credits {
  id: number;
  cast: Cast[];
  crew: Crew[];
}

export interface Person {
  id: number;
  name: string;
  profile_path: string;
}

export interface Cast extends Person {
  character: string;
}

export interface Crew extends Person {
  job: string;
}
