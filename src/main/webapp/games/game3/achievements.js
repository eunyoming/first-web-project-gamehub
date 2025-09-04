// --- 업적 정의 ---
const achievements = {
    // 📌 점수 달성
    MEOW_SCORE_1000: {
        id: "MEOW_SCORE_1000",
        title: "뉴비냥 ? 1000점 달성",
        description: "1000점을 달성했다! 귀엽냥",
        condition: (scene) => scene.score >= 1000,
    },
    MEOW_SCORE_3000: {
        id: "MEOW_SCORE_3000",
        title: "좀 치냥 ? 3000점 달성",
        description: "3000점을 달성했다! 분발해냥",
        condition: (scene) => scene.score >= 3000,
    },
    MEOW_SCORE_7000: {
        id: "MEOW_SCORE_7000",
        title: "핵 썼냥 ? 7000점 달성",
        description: "7000점을 달성했다! 어떻게 했냥",
        condition: (scene) => scene.score >= 7000,
    },

    // 📌 특별 / 히든
    MEOW_FIRST_DEATH: {
        id: "MEOW_FIRST_DEATH",
        title: "죽었냥 ? 첫 사망",
        description: "처음으로 죽었냥",
        condition: (scene) => scene.deathCount === 1,
    },
    MEOW_RESTART_3X: {
        id: "MEOW_RESTART_3X",
        title: "근성냥 ? 포기하지 않는 자",
        description: "근성있냥 연속 3번 재시작",
        condition: (scene) => scene.restartCount >= 3,
    },
    MEOW_DIE_AT_0: {
        id: "MEOW_DIE_AT_0",
        title: "뭐하냥 ? 허무의 죽음",
        description: "오류냥 ? 0점으로 사망",
        condition: (scene) => scene.isGameOver && scene.score === 0,
    },

    // 📌 시간 생존
    MEOW_SURVIVE_30S: {
        id: "MEOW_SURVIVE_30S",
        title: "귀엽냥 30초 버티기",
        description: "30초 동안 생존했다! 귀엽냥",
        condition: (scene) => scene.elapsed >= 30_000,
    },
    MEOW_SURVIVE_1M: {
        id: "MEOW_SURVIVE_1M",
        title: "초보냥 ? 1분 생존",
        description: "1분 동안 생존했다! 초보냥",
        condition: (scene) => scene.elapsed >= 60_000,
    },
    MEOW_SURVIVE_3M: {
        id: "MEOW_SURVIVE_3M",
        title: "중수냥 ? 3분 생존",
        description: "3분 동안 생존했다! 중수냥",
        condition: (scene) => scene.elapsed >= 180_000,
    },
    MEOW_SURVIVE_5M: {
        id: "MEOW_SURVIVE_5M",
        title: "고수냥 ? 5분 생존",
        description: "5분 동안 생존했다! 어떻게 했냥?",
        condition: (scene) => scene.elapsed >= 300_000,
    },

    // 📌 플레이 스타일 / 행동
    MEOW_WALKER: {
        id: "MEOW_WALKER",
        title: "산책냥이",
        description: "총 1,000m 산책한 냥이",
        condition: (scene) => scene.justDodgedClose === true,
    },
    MEOW_AFK_15S: {
        id: "MEOW_AFK_15S",
        title: "잠수냥 ?",
        description: "15초 동안 움직이지 않고 생존! 운 좋냥",
        condition: (scene) => scene.afkTime >= 15_000,
    },
    MEOW_KEEP_MOVING_15S: {
        id: "MEOW_KEEP_MOVING_15S",
        title: "안 힘드냥 ? 끊임없는 움직임",
        description: "15초 동안 계속 움직이기 손 안 아프냥?",
        condition: (scene) => scene.movingTime >= 15_000,
    },
    MEOW_SEE_ALL_PATTERNS: {
        id: "MEOW_SEE_ALL_PATTERNS",
        title: "모든 패턴 경험",
        description: "모든 공격 패턴을 경험했다!",
        condition: (scene) => scene.patternsSeen >= scene.totalPatterns,
    },

};
