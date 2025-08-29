<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/common/manage_header.jsp" />
 <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
 <script src="https://cdn.plot.ly/plotly-3.1.0.min.js" charset="utf-8"></script>
<div class="container">
  <h2 class="mb-4">관리자 대시보드</h2>
  
  <div class="row">
    <div class="col-md-6">
      <div class="card">
        <div class="card-header card-header-main">
          신규 가입자 수 (일/주/월)
        </div>
        <div class="card-body">
         <div>
  <button class="btn btn-blue-main" onclick="loadSignupChart('daily')">일별</button>
  <button class="btn btn-blue-smooth-main" onclick="loadSignupChart('weekly')">주별</button>
  <button class="btn btn-purple-main-black" onclick="loadSignupChart('monthly')">월별</button>
</div>

<canvas id="signupChart" width="600" height="400"></canvas>
        </div>
      </div>
    </div>
    
    <div class="col-md-6">
      <div class="card">
        <div class="card-header card-header-main">
          게임 횟수 상위 10명
        </div>
        <div class="card-body">
        <div>
  <button class="btn btn-red-main" onclick="loadTopGameChart(1)">StarCraft</button>
  <button  class="btn btn-yellow-main"  onclick="loadTopGameChart(2)">Space Battle</button>
  <button class="btn btn-green-main" onclick="loadTopGameChart(3)">Minecraft</button>
   <button class="btn btn-blue-main" onclick="loadTopGameChart(4)">League of Legends</button>
    <button class="btn btn-purple-main-black" onclick="loadTopGameChart(5)">Minecraft</button>
</div>

<canvas id="topGameChart" width="600" height="400"></canvas>
        
       
        </div>
      </div>
    </div>
  </div> <!-- 첫 번째 row 닫기 -->

  <div class="row">
    <div class="col-md-6">
      <div class="card">
        <div class="card-header card-header-navy">
        신규 게시글 수 (일/주/월)
			
        </div>
        <div class="card-body">
           <button class="btn btn-blue-main" onclick="loadPostChart('daily')">일자별</button>
		  <button class="btn btn-blue-smooth-main" onclick="loadPostChart('weekly')">주별</button>
		  <button class="btn btn-purple-main-black" onclick="loadPostChart('monthly')">월별</button>
		  <canvas id="postChart" width="600" height="400"></canvas>
        </div>
      </div>
    </div>
    
    <div class="col-md-6">
      <div class="card">
        <div class="card-header card-header-navy">
          전체 이용자 게임별 플레이 회수
        </div>
        <div class="card-body">
         
           <div id="gamePlayChart"></div>
        </div>
      </div>
    </div>
  </div> <!-- 두 번째 row 닫기 -->
</div> <!-- container 닫기 -->
  <script>
  
  
  let signupChartInstance = null;
  let postChartInstance = null;
  let topGameChartInstance = null;


  function loadSignupChart(type) {
    $.ajax({
      url: '/api/manage/signup-data?type='+type,
      method: 'GET',
      dataType: "json",
      success: function(response) {
        const labels = response.label;
        const dataValues = response.data;
        const maxValue = Math.max(...dataValues);

        const backgroundColors = dataValues.map(v =>
          v === maxValue ? '#DCAAEB' : '#B4E4FF'
        );

        const chartData = {
          labels: labels,
          datasets: [{
            label: '신규 가입 수',
            data: dataValues,
            backgroundColor: backgroundColors,
            borderColor: '#ffffff',
            borderWidth: 2
          }]
        };

        if (signupChartInstance) signupChartInstance.destroy();
        const ctx = document.getElementById('signupChart').getContext('2d');
        signupChartInstance = new Chart(ctx, {
          type: 'bar',
          data: chartData,
          options: {
            responsive: true,
            plugins: {
              legend: { display: false },
              tooltip: {
                callbacks: {
                  label: function(context) {
                    const value = context.raw;
                    return value === maxValue
                      ? `🔥 최고 가입 수: ${value}`
                      : `가입 수: ${value}`;
                  }
                }
              }
            },
            scales: {
              y: { beginAtZero: true }
            }
          }
        });
      }
    });
  }

  function loadPostChart(type) {
    $.ajax({
      url: '/api/manage/post-data?type='+type,
      method: 'GET',
      dataType: "json", 
      success: function(response) {
        const dataValues = response.data;
        const maxValue = Math.max(...dataValues);
	
        const backgroundColors = dataValues.map(v =>
          v === maxValue ? '#DCAAEB' : '#B4E4FF'
        );

        const chartData = {
          labels: response.label,
          datasets: [{
            label: '작성된 게시글 수',
            data: dataValues,
            backgroundColor: backgroundColors,
            borderColor: '#ffffff',
            borderWidth: 2
          }]
        };

        if (postChartInstance) postChartInstance.destroy();
        const ctx = document.getElementById('postChart').getContext('2d');
        postChartInstance = new Chart(ctx, {
          type: 'bar',
          data: chartData,
          options: {
            responsive: true,
            plugins: {
              legend: { display: false },
              tooltip: {
                callbacks: {
                  label: function(context) {
                    const value = context.raw;
                    return value === maxValue
                      ? `📌 최고 게시글 수: ${value}`
                      : `게시글 수: ${value}`;
                  }
                }
              }
            },
            scales: {
              y: { beginAtZero: true }
            }
          }
        });
      }
    });
  }

  
  
  
  //게임 횟수 많은 순 차트
   function loadTopGameChart(gameseq) {
    $.ajax({
      url: '/api/manage/top-players?game='+gameseq, // 서버에서 gameType에 따라 데이터 분기
      method: 'GET',
      dataType: "json",
      success: function(response) {
        const labels = response.label; // 유저 이름 배열
        const dataValues = response.data; // 게임 횟수 배열
        const maxValue = Math.max(...dataValues);

        const backgroundColors = dataValues.map(v =>
          v === maxValue ? '#FF0000' : '#36A2EB'
        );

        const chartData = {
          labels: labels,
          datasets: [{
            label: '게임 횟수',
            data: dataValues,
            backgroundColor: backgroundColors,
            borderColor: '#ffffff',
            borderWidth: 2
          }]
        };

        const config = {
          type: 'bar',
          data: chartData,
          options: {
            indexAxis: 'y',
            responsive: true,
            plugins: {
              legend: { display: false },
              tooltip: {
                callbacks: {
                  label: function(context) {
                    const value = context.raw;
                    return value === maxValue
                      ? `👑 최고 기록: ${value}`
                      : `게임 횟수: ${value}`;
                  }
                }
              }
            },
            scales: {
              x: { beginAtZero: true }
            }
          }
        };

        if (topGameChartInstance) {
          topGameChartInstance.destroy();
        }

        const ctx = document.getElementById('topGameChart').getContext('2d');
        topGameChartInstance = new Chart(ctx, config);
      },
      error: function(err) {
        console.error('데이터 요청 실패:', err);
      }
    });
  }


// 초기 로딩
   loadSignupChart('daily');
   loadPostChart('daily');
   loadTopGameChart('1');

//네번째 차트, 총게임 플레이 횟수 차트
  // 임의 데이터
 $.ajax({
  url: '/api/manage/gamePlayChart',
  method: 'GET',
  dataType: "json",
  success: function(response) {
	 const labels = response.title;
  const values = response.data;
  const maxValue = Math.max(...values);

  const pull = values.map(v => v === maxValue ? 0.1 : 0);

  const data = [{
    type: "pie",
    labels: labels,
    values: values,
    pull: pull, // 최고값만 튀어나오게
    marker: {
      colors: values.map(v => v === maxValue ? "#DCAAEB" : "#B4E4FF"),
      line: {
        color: "#ffffff",
        width: 2
      }
    },
    textinfo: "label+percent",
    hoverinfo: "label+value",
    hole: 0 // 도넛 차트로 바꾸려면 0.4 정도로 설정
  }];

  const layout = {
    title: "게임 기록 차트",
    showlegend: true
  };

  Plotly.newPlot("gamePlayChart", data, layout);
  },
  error: function(error) {
    console.error('데이터 불러오기 실패:', error);
  }
});



  </script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />