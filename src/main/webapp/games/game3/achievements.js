// --- 업적 정의 ---
const achievements = {
  // 📌 시간 생존
  survive_30s: {
    id: "survive_30s",
    title: "30초 버티기",
    description: "30초 동안 생존했다! 귀엽냥",
    condition: (scene) => scene.elapsed >= 30_000,
  },
  survive_1m: {
    id: "survive_1m",
    title: "1분 생존",
    description: "1분 동안 생존했다! 초보냥",
    condition: (scene) => scene.elapsed >= 60_000,
  },
  survive_3m: {
    id: "survive_3m",
    title: "3분 생존",
    description: "3분 동안 생존했다! 중수냥",
    condition: (scene) => scene.elapsed >= 180_000,
  },
  survive_5m: {
    id: "survive_5m",
    title: "5분 생존",
    description: "5분 동안 생존했다! 어떻게 했냥?",
    condition: (scene) => scene.elapsed >= 300_000,
  },

  // 📌 점수 달성
  score_100: {
    id: "score_1000",
    title: "1000점 달성",
    description: "1000점을 달성했다!",
    condition: (scene) => scene.score >= 1000,
  },
  score_500: {
    id: "score_5000",
    title: "5000점 달성",
    description: "5000점을 달성했다!",
    condition: (scene) => scene.score >= 5000,
  },
  score_1000: {
    id: "score_10000",
    title: "10000점 달성",
    description: "10000점을 달성했다! 좀 치냥",
    condition: (scene) => scene.score >= 10000,
  },

  // 📌 플레이 스타일 / 행동
  close_dodge: {
    id: "close_dodge",
    title: "간발의 차 회피",
    description: "화살과 5px 이내에서 회피!",
    condition: (scene) => scene.justDodgedClose === true,
  },
  afk_10s: {
    id: "afk_10s",
    title: "잠수왕",
    description: "30초 동안 움직이지 않고 생존",
    condition: (scene) => scene.afkTime >= 30_000,
  },
  keep_moving_5s: {
    id: "keep_moving_30s",
    title: "끊임없는 움직임",
    description: "30초 동안 계속 움직이기",
    condition: (scene) => scene.movingTime >= 30_000,
  },
  see_all_patterns: {
    id: "see_all_patterns",
    title: "모든 패턴 경험",
    description: "모든 공격 패턴을 경험했다",
    condition: (scene) => scene.patternsSeen >= scene.totalPatterns,
  },

  // 📌 특별 / 히든
  first_death: {
    id: "first_death",
    title: "첫 사망",
    description: "처음으로 죽었다...",
    condition: (scene) => scene.deathCount === 1,
  },
  restart_3x: {
    id: "restart_3x",
    title: "포기하지 않는 자",
    description: "연속 3번 재시작",
    condition: (scene) => scene.restartCount >= 3,
  },
  die_at_0: {
    id: "die_at_0",
    title: "허무의 죽음",
    description: "0점으로 사망",
    condition: (scene) => scene.isGameOver && scene.score === 0,
  }
};
