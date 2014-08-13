class Sky.Conversation
  @Call: (fullName, gender) ->
    "#{if gender then 'Anh' else 'Chị'} #{fullName.split(' ').pop()}"


class Sky.Style
  @Themes: ['green', 'light-green', 'yellow', 'orange', 'blue', 'dark-blue', 'lime', 'pink', 'red', 'purple', 'dark',
             'gray', 'magenta', 'teal', 'turquoise', 'green-sea', 'emeral', 'nephritis', 'peter-river', 'belize-hole',
             'amethyst', 'wisteria', 'wet-asphalt', 'midnight-blue', 'sun-flower', 'carrot', 'pumpkin', 'alizarin',
             'pomegranate', 'clouds', 'sky', 'silver', 'concrete', 'asbestos']

  @RandomColor: => @Themes[Math.floor(Math.random() * @Themes.length)]

class Sky.Util
  @clonePropertyTo: (target, source) => (target[key] = value unless typeof value is 'function') for key, value of source

#Enumerations--------------------->
class Sky.Transports
  @DIRECT:    { value: false, display: 'trực tiếp'}
  @DELIVERY:  { value: true, display: 'giao hàng'}

class Sky.Payments
  @CASH:      { value: 0, display: 'tiền mặt'}
  @DEBT:      { value: 1, display: 'nợ'}

class Sky.Priorities
  @Priority01:      { value: 0, display: 'bình thường'}
  @Priority02:      { value: 1, display: 'Ưu tiên 01'}
  @Priority03:      { value: 2, display: 'Ưu tiên 02'}
  @Priority04:      { value: 3, display: 'Ưu tiên 03'}
