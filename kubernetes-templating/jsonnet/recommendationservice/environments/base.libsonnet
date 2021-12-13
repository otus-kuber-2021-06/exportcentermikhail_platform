
// this file has the baseline default parameters
{
  components: {
    recommendationservice: {
      name: 'recommendationservice',
      image: 'gcr.io/google-samples/microservices-demo/recommendationservice:v0.1.3',
      containerPort: '8080',
      servicePort: '8080'
    },
  },
}
   