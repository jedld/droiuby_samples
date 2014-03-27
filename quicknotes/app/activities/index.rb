
require 'active_support/json'

class Index < Activity

	def on_create

		@notes = get_notes
		@notes_container = V('#items')


		render_notes

		V('#add').on(:click) do |view|

			note_text_field = V('#note')
			@notes << note_text_field.text
			note_text_field.text = ""
			render_notes

		end
		
	end

	def on_activity_result(request_code, result_code, intent)
	  #callback from starting an activity with result
	end

	private

	def render_notes
		@notes_container.remove_all_views
		@notes.each do |note|
				@notes_container << "<t width='match' >#{note}</t>"
		end
	end

	def get_notes
		if _P.has_key?(:notes)
			JSON.parse(_P.get(:notes))
		else
			[]
		end
	end

	def save_notes(notes = [])
		_P.update_attributes!(notes: notes.to_json)
	end
end
