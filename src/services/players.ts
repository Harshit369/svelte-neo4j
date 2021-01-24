import type { Session } from "neo4j-driver";
import type { Player } from "../entities/player";

export interface PlayerFilter {
  id: Player["id"];
  name: Player["name"];
}

export default function players(db: Session) {
  return {
    getAll({ search }: { search: string }): Promise<Player[]> {
      return db
        .run(
          "Match (player: Player) Where player.name CONTAINS $search return player",
          { search }
        )
        .then((data) => {
          return data.records.map(
            (r) => (r.toObject() as any).player.properties
          );
        });
    },
  };
}
