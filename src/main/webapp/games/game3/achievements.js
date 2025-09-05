// --- 업적 정의 ---
const achievements = {
	// 📌 점수 달성
	MEOW_SCORE_1000: {
		id: "MEOW_SCORE_1000",
		title: "1000점 달성 뉴비냥",
		description: "1000점을 달성했다! 귀엽냥",
		condition: (scene) => scene.score >= 1000,
	},
	MEOW_SCORE_3000: {
		id: "MEOW_SCORE_3000",
		title: "3000점 달성 좀 치는냥",
		description: "3000점을 달성했다! 분발해냥",
		condition: (scene) => scene.score >= 3000,
	},
	MEOW_SCORE_7000: {
		id: "MEOW_SCORE_7000",
		title: "7000점 달성 핵쟁이냥",
		description: "7000점을 달성했다! 어떻게 했냥",
		condition: (scene) => scene.score >= 7000,
	},

	// 📌 특별 / 히든
	MEOW_FIRST_DEATH: {
		id: "MEOW_FIRST_DEATH",
		title: "화살 피했냥의 첫번째 피해냥",
		description: "첫 죽음이냥?",
		condition: (scene) => scene.deathCount === 1,
	},
	MEOW_RESTART_3X: {
		id: "MEOW_RESTART_3X",
		title: "화살 좀 피한냥",
		description: "근성있냥 연속 3번 재시작  Point + 300",
		condition: (scene) => scene.restartCount >= 3,
	},
	MEOW_RESTART_10X: {
		id: "MEOW_RESTART_10X",
		title: "화살 피하기 중독된냥",
		description: "연속 10번 재시작! 중독됐냥?",
		condition: (scene) => scene.isGameOver && scene.score === 0,
	},

	// 📌 시간 생존
	MEOW_SURVIVE_30S: {
		id: "MEOW_SURVIVE_30S",
		title: "30초 버틴 뉴비냥",
		description: "30초 동안 생존했다! 뉴비 귀엽냥",
		condition: (scene) => scene.elapsed >= 30_000,
	},
	MEOW_SURVIVE_1M: {
		id: "MEOW_SURVIVE_1M",
		title: "1분 생존 초보냥",
		description: "1분 동안 생존했다! 초보냥",
		condition: (scene) => scene.elapsed >= 60_000,
	},
	MEOW_SURVIVE_2M: {
		id: "MEOW_SURVIVE_2M",
		title: "2분 생존 중수냥",
		description: "2분 동안 생존했다! 중수냥",
		condition: (scene) => scene.elapsed >= 120_000,
	},
	MEOW_SURVIVE_3M: {
		id: "MEOW_SURVIVE_3M",
		title: "3분 생존 고수냥",
		description: "3분 동안 생존했다! 어떻게 했냥?",
		condition: (scene) => scene.elapsed >= 180_000,
	},
	MEOW_SURVIVE_5M: {
		id: "MEOW_SURVIVE_5M",
		title: "5분 생존 만렙냥",
		description: "5분 동안 생존했다! 핵 썼냥?",
		condition: (scene) => scene.deathCount === 1,
	},

	// 📌 플레이 스타일 / 행동
	MEOW_AFK_15S: {
		id: "MEOW_AFK_15S",
		title: "잠수냥",
		description: "15초 동안 움직이지 않고 생존! 운 좋냥",
		condition: (scene) => scene.afkTime >= 15_000,
	},
	MEOW_KEEP_MOVING_15S: {
		id: "MEOW_KEEP_MOVING_15S",
		title: "에너자이저냥",
		description: "15초 동안 계속 움직이기 에너자이저냥",
		condition: (scene) => scene.movingTime >= 15_000,
	},
	MEOW_SEE_ALL_PATTERNS: {
		id: "MEOW_SEE_ALL_PATTERNS",
		title: "패턴 다 아는냥",
		description: "모든 공격 패턴을 경험했다!",
		condition: (scene) => scene.patternsSeen >= scene.totalPatterns,
	},

};
