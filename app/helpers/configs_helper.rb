module ConfigsHelper

  def badge_is_public(config)
    badge, btitle = if config.is_public
    else
      ['<i class="fa fa-eye-slash" aria-hidden="true"></i>', 'Hidden']
    end

    badge.present? ? "<span class='badge' title='#{btitle}'>#{badge}</span>".html_safe : ""
  end

end
