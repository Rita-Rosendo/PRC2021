import Vue from 'vue'
import VueRouter from 'vue-router'
import Pubs from '../views/Pubs.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/pubs',
    name: 'Pubs',
    component: Pubs
  },
  {
    path: '/authors',
    name: 'Authors',
    component: () => import('../views/Authors.vue')
  },
  {
    path: '/Authors/:idAuthor',
    name: 'Author',
    component: () => import( '../views/Author.vue')
  },
  {
    path: '/pubs/:idPub',
    name: 'Pub',
    component: () => import('../views/Pub.vue')
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
