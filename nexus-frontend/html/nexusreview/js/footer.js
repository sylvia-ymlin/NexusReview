Vue.component("footBar", {
  template: `
    <div class="foot">
    <div class="foot-box" :class="{active: activeBtn === 1}" @click="toPage(1)">
      <img :src="activeBtn === 1 ? '/imgs/icons/home.png' : '/imgs/icons/home.png'" class="nav-icon">
      <div class="foot-text">Hem</div>
    </div>
    <div class="foot-box" :class="{active: activeBtn === 2}" @click="toPage(2)">
      <img :src="activeBtn === 2 ? '/imgs/icons/map.png' : '/imgs/icons/map.png'" class="nav-icon">
      <div class="foot-text">Upptäck</div>
    </div>
    <div class="foot-box" @click="toPage(0)">
      <img class="add-btn" src="/imgs/icons/add.png" alt="">
    </div>
    <div class="foot-box" :class="{active: activeBtn === 3}" @click="toPage(3)">
      <img :src="activeBtn === 3 ? '/imgs/icons/chat.png' : '/imgs/icons/chat.png'" class="nav-icon">
      <div class="foot-text">Meddelanden</div>
    </div>
    <div class="foot-box" :class="{active: activeBtn === 4}" @click="toPage(4)">
      <img :src="activeBtn === 4 ? '/imgs/icons/profile.png' : '/imgs/icons/profile.png'" class="nav-icon">
      <div class="foot-text">Profil</div>
    </div>
  </div>
  `,
  data() {
    return {
    }
  },
  props: ['activeBtn'],
  methods: {
    toPage(i) {
      if (i === 0) {
        location.href = "/blog-edit.html"
      } else if (i === 4) {
        location.href = "/info.html"
      } else if (i === 1){
        location.href = "/"
      }
    }
  }
})