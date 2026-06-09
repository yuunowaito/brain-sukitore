import { Controller } from "@hotwired/stimulus"
import { Chart, LineController, LineElement, PointElement, LinearScale, CategoryScale, Filler, Tooltip } from "chart.js"

Chart.register(LineController, LineElement, PointElement, LinearScale, CategoryScale, Filler, Tooltip)

export default class extends Controller {
  static targets = ["canvas", "legendText"]
  static values  = { chartJson: Object }

  connect() {
    const firstGame = Object.keys(this.chartJsonValue)[0]
    this._buildChart(firstGame)
    if (this.hasLegendTextTarget) {
      this.legendTextTarget.textContent = `${firstGame}スコア推移`
    }
  }

  disconnect() {
    this.chart?.destroy()
  }

  switchTab(e) {
    const game = e.currentTarget.dataset.game

    this.element.querySelectorAll("[data-game]").forEach(btn => {
      btn.classList.toggle("btn-primary", btn.dataset.game === game)
      btn.classList.toggle("btn-ghost", btn.dataset.game !== game)
    })

    const d = this.chartJsonValue[game]
    this.chart.data.labels = d.labels
    this.chart.data.datasets[0].data = d.datasets[0].data
    this.chart.update()

    if (this.hasLegendTextTarget) {
      this.legendTextTarget.textContent = `${game}スコア推移`
    }
  }

  _buildChart(game) {
    const d = this.chartJsonValue[game]
    this.chart = new Chart(this.canvasTarget, {
      type: "line",
      data: {
        labels: d.labels,
        datasets: [{
          data: d.datasets[0].data,
          borderColor: "#059669",
          backgroundColor: "rgba(5,150,105,0.15)",
          borderWidth: 2,
          pointRadius: 4,
          tension: 0.35,
          fill: true
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true } }
      }
    })
  }
}