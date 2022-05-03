# Title: A better YouTube embed tag for Jekyll
# Author: Tuan Anh Tran <http://tuananh.org>
# Description: Out put a beautiful thumbnail image. Change to iframe on click.
# Examples:
# {% youtube /v8o-Vd__I-A 560 315 %}
# {% youtube http://youtu.be/v8o-Vd__I-A %}

module Jekyll
  class BetterTube < Liquid::Tag
    @ytid = nil
    @width = ''
    @height = ''

    def initialize(tag_name, markup, tokens)
      if markup =~ /(?:(?:https?:\/\/)?(?:www.youtube.com\/(?:embed\/|watch\?v=)|youtu.be\/)?(\S+)(?:\?rel=\d)?)(?:\s+(\d+)\s(\d+))?/i
        @ytid = Regexp.last_match(1)
        @width = Regexp.last_match(2) || '560'
        @height = Regexp.last_match(3) || '315'
      end
      super
    end

    def render(context)
      # puts "Context: #{context.registers[:amp].inspect}"
      # raise StandardError, "Hoi!"
      ouptut = super
      if @ytid
        return render_amp(context) if context.registers[:amp]

        id = @ytid
        w = @width
        h = @height
        intrinsic = ((h.to_f / w.to_f) * 100)
        padding_bottom = ('%.2f' % intrinsic).to_s + '%'

        thumbnail = "<figure class='BetterTube' data-youtube-id='#{id}' data-player-width='#{w}' data-player-height='#{h}' id='#{id}' style='padding-bottom: #{padding_bottom}'><a class='BetterTubePlayer' href='http://www.youtube.com/watch?v=#{id}' style='background: url(http://img.youtube.com/vi/#{id}/hqdefault.jpg) 50% 50% no-repeat rgb(0, 0, 0);'>&nbsp;</a><div class='BetterTube-playBtn'></div>&nbsp;</figure>"

        video = thumbnail.to_s

      else
        'Error while processing. Try: {% youtube video_id [width height] %}'
      end
    end

    def render_amp(_context)
      video = "<amp-youtube data-videoid='#{@ytid}' width='358' height='204' layout='responsive'><amp-img src='https://i.ytimg.com/vi/#{@ytid}/hqdefault.jpg' placeholder layout='fill' /></amp-youtube>"
    end
  end
end

Liquid::Template.register_tag('youtube', Jekyll::BetterTube)
