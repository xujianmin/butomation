class VirtualUser < ApplicationRecord
  # 配置搜索
  include PgSearch::Model
  pg_search_scope :text_search,
    against: [ :last_name, :first_name, :email ],
    using: {
      tsearch: {
        any_word: true,
        prefix: true
      }
    }

  # 搜索相关
  FILTERS_PARAMS = %i[query sort].freeze

  scope :search, ->(query) { query.present? ? text_search(query) : all }
  scope :sorted, ->(selection) { selection.present? ? apply_sort(selection) : all }

  def self.apply_sort(selection)
    sort, direction = selection.split("-")
    order("virtual_users.#{sort} #{direction}")
  end

  def self.filter(filters)
    includes(:pokermon)
      .search(filters["query"])
      .sorted(filters["sort"])
  end

  # 校验数据
  validates :email, presence: true
  validates :birthdate, presence: true

  # 模型关联
  has_one :pokermon, class_name: "Sites::Pokermon", dependent: :destroy

  # 与User的多对多关联
  has_many :subordinations, dependent: :destroy
  has_many :users, through: :subordinations

  enum :civ_style, {
    china: "中国",
    japan: "日本",
    west: "西方"
  }, prefix: true

  enum :domain, {
    pukapuka2025: "pukapuka2025.com",
    drexopy:      "drexopy.com",
    cooooldash:   "cooooldash.com",
    wulimail:     "wulimail.com",
    truetora:     "truetora.com",
    "8bitone":    "8bitone.com",
    litboxnet:    "litboxnet.com",
    glowinow:     "glowinow.com",
    nxtmails:     "nxtmails.com",
    playbafun:    "playbafun.com",
    wavescoming:  "wavescoming.com",
    xyzonexyz:    "xyzonexyz.com",
    cybroiday:    "cybroiday.com",
    zzplayzz:     "zzplayzz.com",
    bitwandering: "bitwandering.com",
    revelmon:     "revelmon.com",
    codevibest:   "codevibest.com",
    bitzwild:     "bitzwild.com",
    trytrywaves:  "trytrywaves.com",
    urbantok:     "urbantok.com",
    looplaab:     "looplaab.com",
    bytefluxit:   "bytefluxit.com",
    metazhidao:   "metazhidao.com",
    xinlime:      "xinlime.com",
    nihencool:    "nihencool.com"
  }, prefix: true

  def fullname
    if civ_style_china? || civ_style_japan?
      "#{last_name}#{first_name}"
    else
      "#{first_name} #{last_name}"
    end
  end

  def email_address
    email + "@" + self.class.domains[domain]
  end

  def age
    return nil unless birthdate
    now = Time.current.to_date
    now.year - birthdate.year - (birthdate.change(year: now.year) > now ? 1 : 0)
  end

  # 分配给用户
  def assign_to_user(user)
    users << user unless users.include?(user)
  end

  # 从用户移除
  def remove_from_user(user)
    users.delete(user)
  end

  # 检查是否被某个用户管理
  def managed_by_user?(user)
    users.include?(user)
  end

  # 获取主要管理者（第一个分配的用户）
  def primary_manager
    users.first
  end

  def generate_random_birthdate
    today = Date.today
    min_age = 18
    max_age = 75

    # 计算最小和最大生日
    max_birthdate = today - min_age.years
    min_birthdate = today - max_age.years

    # 生成随机日期
    days_range = (min_birthdate..max_birthdate).count
    random_days = rand(days_range)

    min_birthdate + random_days
  end

  # 生成中国姓氏
  def cn_last_name
    [
      "王", "李", "张", "刘", "陈", "杨", "黄", "赵", "吴", "周", "徐", "孙", "马",
      "朱", "胡", "林", "郭", "何", "高", "罗", "郑", "梁", "谢", "宋", "唐", "许",
      "邓", "冯", "韩", "曹", "袁", "邓", "许", "傅", "沈", "曾", "彭", "吕", "苏",
      "卢", "蒋", "蔡", "贾", "丁", "魏", "薛", "叶", "阎", "余", "潘", "杜", "戴",
      "夏", "钟", "汪", "田", "任", "姜", "范", "方", "石", "姚", "谭", "廖", "邹",
      "熊", "金", "陆", "郝", "孔", "白", "崔", "康", "毛", "邱", "秦", "江", "史",
      "顾", "侯", "邵", "孟", "龙", "万", "段", "雷", "钱", "汤", "尹", "黎", "易",
      "常", "武", "乔", "贺", "赖", "龚", "文", "庞", "樊", "兰", "殷", "施", "陶",
      "洪", "翟", "安", "颜", "倪", "严", "牛", "温", "芦", "季", "俞", "章", "鲁",
      "葛", "伍", "韦", "申", "尤", "毕", "聂", "丛", "焦", "向", "柳", "邢", "路",
      "岳", "齐", "沿", "梅", "莫", "庄", "辛", "管", "祝", "左", "涂", "谷", "盛",
      "耿", "牟", "卜", "路", "詹", "关", "苗", "凌", "费", "纪", "靳", "盛", "童",
      "欧", "甄", "项", "曲", "成", "游", "阳", "裴", "席", "卫", "查", "屈", "鲍",
      "位", "覃", "霍", "翁", "隋", "植", "甘", "景", "薄", "单", "包", "司", "柏",
      "宁", "柯", "阮", "桂", "闵", "解", "强", "柴", "华", "车", "冉", "房", "边",
      "欧阳", "上官", "司马", "夏侯", "诸葛", "闻人", "东方", "赫连", "皇甫", "尉迟",
      "公羊", "澹台", "公冶", "宗政", "濮阳", "淳于", "单于", "太叔", "申屠", "公孙",
      "仲孙", "轩辕", "令狐", "钟离", "宇文", "长孙", "慕容", "鲜于", "闾丘", "司徒",
      "司空", "亓官", "司寇", "仉督", "子车", "颛孙", "端木", "巫马", "公西", "漆雕",
      "乐正", "壤驷", "公良", "拓跋", "宰父", "谷粱", "晋楚", "闫法", "汝鄢", "涂钦",
      "段干", "百里", "东郭", "南门", "呼延", "羊舌", "微生", "岳帅", "有琴", "梁丘",
      "左丘", "东门", "西门", "南宫"
    ].sample
  end

  # 生成中国名字
  def cn_first_name(gender)
    male_chars = [
                  "伟", "强", "军", "杰", "刚", "勇", "斌", "磊", "涛", "明", "辉",
                  "超", "峰", "旭", "光", "建", "国", "平", "安", "志", "忠", "德",
                  "清", "飞", "云", "林", "海", "洋", "波", "鹏", "坤", "豪", "亮",
                  "剑", "俊", "雄", "宇", "浩", "天", "泽", "瑞", "祥", "庆", "利",
                  "兴", "良", "仁", "义", "礼", "智", "信", "春", "夏", "秋", "冬",
                  "晨", "阳", "星", "月", "雷", "电", "山", "川", "河", "流", "江",
                  "湖", "田", "野", "村", "庄", "福", "禄", "寿", "喜", "财", "富",
                  "贵", "文", "武", "新", "中", "华", "民", "族", "世", "代", "宗",
                  "祖", "先", "贤"
                ]
    female_chars = [
                  "芳", "娜", "丽", "娟", "敏", "静", "英", "华", "文", "惠", "兰",
                  "凤", "琴", "美", "霞", "雪", "琳", "艳", "婷", "佳", "琼", "珍",
                  "珠", "玉", "秀", "荣", "莉", "雅", "芝", "梅", "萍", "红", "彩",
                  "春", "花", "月", "云", "梦", "晓", "青", "紫", "香", "烟", "柳",
                  "竹", "桃", "杏", "莲", "荷", "蝶", "燕", "莺", "娇", "柔", "巧",
                  "容", "颜", "眉", "眼", "心", "爱", "思", "念", "情", "意", "慧",
                  "智", "诗", "书", "画", "琴", "棋", "绣", "锦", "丝", "线", "银",
                  "翠", "金", "宝", "环", "佩", "瑶", "琳", "玲", "珑", "琪", "瑛",
                  "珊", "瑚", "珠", "翠", "黛", "素", "雅", "静", "宜", "宁"
                ]

    name_chars = gender == "男" ? male_chars : female_chars
    name_length = [ 1, 2 ].sample

    name_length.times.map { name_chars.sample }.join
  end

  # 生成日本姓氏
  def jp_last_name
    [
      "佐藤", "铃木", "高桥", "田中", "渡边", "伊藤", "山本", "中村", "小林", "斋藤", "加藤",
      "吉田", "山田", "佐佐木", "山口", "松本", "井上", "木村", "林", "清水", "山崎", "中岛",
      "池田", "阿部", "桥本", "山下", "森", "石川", "前田", "小川", "藤田", "冈田", "后藤",
      "长谷川", "石井", "村上", "近藤", "坂本", "远藤", "青木", "藤本", "村田", "武田", "上野",
      "杉山", "增田", "小山", "大冢", "平野", "菅原", "久保", "松井", "千叶", "岩崎", "樱井",
      "木下", "野口", "松尾", "菊地", "野村", "新井", "渡部", "佐野", "杉本", "大西", "古川",
      "滨田", "市川", "小松", "高野", "水野", "吉川", "山内", "西田", "西川", "菊池", "北村",
      "五十岚", "福岛", "安田", "中田", "平田", "川口", "川崎", "饭田", "东", "本田", "泽田",
      "久保田", "吉村", "中西", "岩田", "服部", "辻", "关", "藤原", "源", "平", "橘", "中臣",
      "物部", "苏我", "大江", "清原", "在原", "日下部", "惟宗", "秦氏", "安倍", "足利", "伊达",
      "福泽", "北条", "本多", "前田", "松平", "织田", "真田", "岛津", "武田", "毛利", "德川"
    ].sample
  end

  def jp_first_name(gender)
    male_chars = [
                  "健太", "大輔", "拓真", "悠太", "翔太", "健一", "大翔", "裕樹", "拓哉",
                  "健太郎", "大輝", "悠人", "俊介", "雄大", "翔平", "亮介", "良太", "健史",
                  "大介", "裕太", "拓也", "悠輝", "俊輔", "雄一", "翔輔", "亮太", "良輔",
                  "健吾", "大智", "裕介", "拓真", "悠介", "俊太", "雄輔", "翔一", "亮輝",
                  "良一", "健太朗", "大翔輔", "裕樹", "拓哉", "悠太", "俊介", "雄大", "翔平",
                  "亮介", "良太", "健史", "大介", "裕太", "拓也", "悠輝", "俊輔", "雄一", "翔輔",
                  "亮太", "良輔", "健吾", "大智", "裕介", "拓真", "悠介", "俊太", "雄輔", "翔一",
                  "亮輝", "良一", "健太朗", "大翔輔", "裕樹", "拓哉", "悠太", "俊介", "雄大", "翔平",
                  "亮介", "良太", "健史", "大介", "裕太", "拓也", "悠輝", "俊輔", "雄一", "翔輔", "亮太",
                  "良輔", "健吾", "大智", "裕介"
                ]

    female_chars = [
                    "愛", "美咲", "結衣", "桜", "琴子", "沙耶香", "優花", "真央", "千夏", "葵",
                    "涼子", "彩乃", "里奈", "明日香", "鈴", "加奈", "詩織", "恵梨香", "美雪", "由紀",
                    "菜々子", "桜子", "茉莉", "智子", "楓", "陽子", "花", "瑠璃", "美由紀", "真希",
                    "桃子", "京子", "莉子", "舞", "雪", "瞳", "夏美", "小百合", "美羽", "愛子",
                    "裕子", "理絵", "麻美", "春香", "美穂", "陽子", "直子", "由美", "香織", "真紀",
                    "千秋", "朋子", "雪子", "幸子", "祥子", "智恵子", "明美", "和子", "光子", "久美子",
                    "芳子", "陽子", "雅子", "美代子", "佳代子", "喜代子", "京子", "和枝", "節子", "妙子",
                    "春江", "静香", "良子", "美智子", "貞子", "淑子", "孝子", "礼子", "信子", "恵子", "祥子",
                    "芳江", "清子", "容子", "淑江", "京子", "美智", "由美子", "良江", "路子"
                  ]

    name_chars = gender == "男" ? male_chars : female_chars
    name_chars.sample
  end

  # 随机生成 VirtualUser 的属性
  def randomize_virtual_user
    self.civ_style = VirtualUser.civ_styles.keys.sample
    self.gender = Faker::Gender.binary_type == "Male" ? "男" : "女"

    case self.civ_style
    when "west"
      if self.gender == "男"
        I18n.with_locale(:en) do
          self.first_name = Faker::Name.male_first_name
          self.last_name = Faker::Name.last_name
        end
      else
        I18n.with_locale(:en) do
          self.first_name = Faker::Name.female_first_name
          self.last_name = Faker::Name.last_name
        end
      end
    when "china"
      self.first_name = cn_first_name(self.gender)
      self.last_name = cn_last_name
    when "japan"
      self.first_name = jp_first_name(self.gender)
      self.last_name = jp_last_name
    end

    self.email = Faker::Internet.username(specifier: 1..8)
    self.domain = VirtualUser.domains.keys.sample

    self.birthdate = generate_random_birthdate
  end
end
