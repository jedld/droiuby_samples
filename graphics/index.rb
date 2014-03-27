#droiuby ruby script
class Index < Activity

  def on_create
      # Array where we will store our points
      image_x = 0
      image_y = 0
      points = []

      # Download image and create a view when image has been downloaded
      AssetHandler.download('http://developer.android.com/images/brand/Android_Robot_200.png').done { |image|
          surface_view = surface { |v|
               v.on(:surface_created) { |holder|
                  @running = true

                  # Create the "Render Thread"
                  current_fps = 0
                  @render_thread = _thread {
                      frame = 0
                      start_frame_time = _time
                      i = 0
                      avg_fps = 0
                      begin
                          holder.lock { |g|
                              g.draw_color '#FFFFFF'
                              g.bitmap image, image_x, image_y
                              g.bitmap image, 480- image_x, image_y + 200

                              points.each { |point|
                                  g.circle point[:x], point[:y], 5
                              }

                              g.round_rect(g.make_rect(0,300,200,340),100,100)
                              frame += 1
                          }
                          now = _time
                          if now > start_frame_time + 1000
                              start_frame_time = now

                              avg_fps += frame
                              if i > 10
                                  i = 0
                                  log_debug  "AVG FPS: #{avg_fps/10}"
                                  avg_fps = 0
                              else
                                  i += 1
                              end
                              frame = 0
                          end

                      end while @running
                  }.start

                    #create the game thread
                  @game_thread = _thread  {
                      begin
                          image_x += 1
                          image_x = 0 if image_x > 480
                          _sleep 1
                      end while @running
                  }.start


                  v.on(:surface_destroyed) { |holder|
                      log_debug "surface destroyed"
                      @running = false
                  }

                  V('#clear').on(:click) { |view|
                      points = []
                      holder.lock { |g|
                          g.draw_color '#FFFFFF'
                      }
                  }

                  v.on(:touch) { |view, touches|
                      log_debug "touch called!"
                      points << {x: touches.x, y: touches.y}
                  }
              }


          }

          V('#canvas').append(surface_view)


      }.start
  end

  def on_activity_reload

  end
end
