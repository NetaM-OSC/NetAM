<script>
import DoughnutChart from '../charts/pieChart'
import axios from "axios";

export default {
  props: {
    id: {
      type: String,
      required: true
    }
  },
  components: { DoughnutChart },
  data: () => ({
    loaded: false,
    chartdata: null,
    options: {
      legend: {
        labels: {
          fontColor: "#6B7280"
        },
        position: "right"
      },
      tooltips: {
        mode: "index",
        intersect: false
      },
      hover: {
        mode: "nearest",
        intersect: true
      }
    }
  }),
  async mounted () {
    axios.get('/admin/api/sections/' + this.id).then((response) => {
      this.chartdata = response.data
      this.loaded = true
    }).catch((e) => {
      console.error(e)
    })
  },
  computed: {
    styles () {
      return {
        height: '350px',
        width: '350px',
        margin: '-50px'
      }
    }
  }
}
</script>

<template>
  <doughnut-chart v-if="loaded" :chartdata="chartdata" :options="options" :styles="styles"/>
</template>
