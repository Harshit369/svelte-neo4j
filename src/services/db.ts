import { driver, auth, Session, session } from "neo4j-driver";

import playerService from './players'

export const driverInstance = driver(
  // @ts-ignore
  process.env.DB_URL,
  // @ts-ignore
  auth.basic(process.env.DB_USER, process.env.DB_PASSWORD)
);

function DB(session: Session) {
  return {
    player: playerService(session)
  };
}

export default DB(driverInstance.session({ defaultAccessMode: session.READ }));
