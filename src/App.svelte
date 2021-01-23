<script lang="ts">
  import { here } from "await-here";
  import type { Player } from "./entities/player";
  import db from "./services/db";

  let players: Player[] = [];

  async function searchPlayer(e) {
    const [err, records] = await here(
      db.player.getAll({ search: e.target.value })
    );
    if (!err) {
      players = records;
    }
  }
</script>

<main>
  <h1>Hello!</h1>
  <input on:keyup={searchPlayer} />

  {#each players as player}
    <p>{player.name}</p>
  {/each}
</main>

<style>
  main {
    text-align: center;
    padding: 1em;
    max-width: 240px;
    margin: 0 auto;
  }

  h1 {
    color: #ff3e00;
    text-transform: uppercase;
    font-size: 4em;
    font-weight: 100;
  }

  @media (min-width: 640px) {
    main {
      max-width: none;
    }
  }
</style>
