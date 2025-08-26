<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/common/manage_header.jsp" />
 <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
   <div class="container">
    <h2 class="mb-4">관리자 대시보드</h2>

    <div class="row">
      <div class="col-md-6">
        <div class="card">
          <div class="card-header">
            일자별 신규 가입자 수
          </div>
          <div class="card-body">
            <canvas id="scoreChart"></canvas>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script>
    // 야매 데이터 (임시)
    //나중에는 ajax로 controller에게 요청해서 labels와 data만 바꾸면 될듯?
   const labels = ["2025-08-19", "2025-08-20", "2025-08-21", "2025-08-22", "2025-08-23", "2025-08-24", "2025-08-25"];
const data = [12, 18, 9, 20, 15, 30, 25]; // 예시: 일자별 신규 가입자 수

const ctx = document.getElementById("scoreChart").getContext("2d");

new Chart(ctx, {
  type: "line",
  data: {
    labels: labels,
    datasets: [{
      label: "신규 가입자 수",
      data: data,
      borderColor: "#B4E4FF",
      backgroundColor: "#B1D8FF",
      fill: true,
      tension: 0.3,
      pointBackgroundColor: "#fff",
      pointBorderColor: "#C7BCFA",
      pointRadius: 5
    }]
  },
  options: {
    responsive: true,
    plugins: {
      legend: {
        display: true
      },
      tooltip: {
        callbacks: {
          label: function(context) {
            return "신규 가입자 수: " + context.raw + "명";
          }
        }
      }
    },
    scales: {
      x: {
        title: {
          display: true,
          text: "날짜"
        }
      },
      y: {
        title: {
          display: true,
          text: "가입자 수"
        },
        beginAtZero: true
      }
    }
  }
});
  </script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />