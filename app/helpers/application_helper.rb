module ApplicationHelper
  def resource_name
    :hiker
  end

  def resource
    @resource ||= Hiker.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:hiker]
  end

  def timediff_string to, from=Time.now
    unit = "minute"

  	timeleft = (to - from).to_i / 1.minute
    show_as_date = false
    add_str_suff = ""
    add_str_pref = "in "
    if timeleft < 0
      add_str_suff = " ago"
      timeleft = timeleft*-1
      add_str_pref = ""
    end
  	if timeleft>59
      unit = "hour"
  	  timeleft= timeleft / 60
      if timeleft >= 24
        unit = "day"
        # timeleft = timeleft / 24
        # if timeleft >=7
        #   unit = "week"
        #   timeleft = timeleft / 7
        #   if timeleft >=4
        #     unit = "month"
        #     timeleft = timeleft/4
        #   end
        # end
        unit = to.strftime("%B %d at %H:%Mh")
        show_as_date=true
        timeleft=1
   	  end
    end

    if timeleft > 1
      unit = unit+"s"
    end
    if(!show_as_date)
      result=add_str_pref+timeleft.to_s + " " + unit + add_str_suff
    else
      result=unit
    end
  end

  def fetch_notifications hiker 
  requests = Request.all.where(dinner_id: Dinner.all.where(hiker: hiker)).order('created_at').reverse_order
  notifications = Array.new(requests.size)
    requests.each_index do |req_index|
      notifications[req_index] = Notification.new(
        date: requests[req_index].created_at,
        subject: "Request received for '"+requests[req_index].dinner.title+"'.",
        desc: requests[req_index].body,
        picture_url: requests[req_index].dinner.picture.url,
        icon: "icon-envelope")
    end

    return notifications
  end

end
