class AdminData
  def initialize(year)
    @year = year
    @event = Event.find_by(year: @year)
    @players = EventPlayer.where(event: @event)
    @eps = EventPlayerScore.where(event_player: @players)
  end

  def name
    @event.display_name
  end

  def host_flag
    @event.country.xl_image
  end

  def countries
    @event.participating_countries.map do |pc|
      if pc.player.present?
        ["#{pc.country.name}#{" (#{pc.player.display_name})"}"]
      else
        [pc.country.name]
      end << eps_counts(@eps.where(participating_country_id: pc.id))
    end
  end

  private

  def eps_counts(particpating_country_eps)
    [
      particpating_country_eps.where.not(score: nil).count,
      particpating_country_eps.where.not(score: nil).sum(:score),
      particpating_country_eps.where(best_wail: true).count,
      particpating_country_eps.where(fattest: true).count,
      particpating_country_eps.where(wackiest: true).count
    ]
  end
end
