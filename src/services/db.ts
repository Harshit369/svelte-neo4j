import { driver, auth, Session, session } from "neo4j-driver";
import config from "../config";

import playerService from "./players";

export const driverInstance = driver(
  config.DB_URL,
  auth.basic(config.DB_USER, config.DB_PASSWORD)
);

function DB(session: Session) {
  return {
    player: playerService(session),
  };
}

export default DB(
  driverInstance.session({
    defaultAccessMode: session.READ,
    database: config.DB_NAME,
  })
);
