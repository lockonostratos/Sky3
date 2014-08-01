class Sky.Conversation
  @Call = (fullName, gender) ->
    "#{if gender then 'Anh' else 'Chị'} #{fullName.split(' ').pop()}"

#Enumerations--------------------->
class Sky.Transports
  @DIRECT:    { value: 0, display: 'trực tiếp'}
  @DELIVERY:  { value: 1, display: 'giao hàng'}

class Sky.Payments
  @CASH:      { value: 0, display: 'tiền mặt'}
  @DEBT:      { value: 1, display: 'nợ'}
