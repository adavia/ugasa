require 'squid'

class AnnualReportPdf
  include Prawn::View

  def initialize(client, invoices, year)
    font_setup 
    @client = client
    @invoices = invoices
    @year = year
    header
    current_date
    body_content
    signature
    footer
  end

  def font_setup
    font_families.update("OpenSans" => {
      :normal => "#{Rails.root}/app/assets/fonts/OpenSans-Regular.ttf",
      :italic => "#{Rails.root}/app/assets/fonts/OpenSans-Italic.ttf",
      :bold   => "#{Rails.root}/app/assets/fonts/OpenSans-Bold.ttf"
    })

    font "OpenSans"
  end

  def header
    y_position = cursor - 10
    
    bounding_box([0, y_position - 10], width: 270) do
      text "Campaña permanente de Recolección de", size: 10, style: :bold, color: "959595", align: :center
      move_down 5
      text "Aceite Vegetal Usado (AVU)", size: 10, style: :bold, color: "79B265", align: :center
      move_down 7
      text "<color rgb='547C46'>No</color> lo tires al drenaje, contamina el agua y los suelos.", inline_format: true, size: 8, color: "959595", align: :center
      move_down 5
      text "<color rgb='547C46'>No</color> lo revendas, causa daño a la salud.", inline_format: true, size: 8, color: "959595", align: :center
    end

    #This inserts an image in the pdf file and sets the size of the image
    bounding_box([300, y_position], width: 240, height: 100) do
      image "#{Rails.root}/app/assets/images/logo_uga.png", width: 230, position: :right
    end
  end

  def current_date
    text "Cancún, Q. Roo. a #{I18n.l(Time.now, format: '%d %B de %Y')}", align: :right, color: "959595"
  end

  def body_content
    # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
    y_position = cursor - 20

    data = { "Litros de aceite": @invoices }

    # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
    bounding_box([0, y_position], :width => 540) do
      text @client.social_name.upcase, size: 15, style: :bold, color: "959595"
      move_down 8
      text "PRESENTE", leading: 15, color: "959595"
      text "La recolección de Aceite Vegetal Usado (AVU), residuo de su operación normal, forma parte fundamental de un movimiento, que deseamos se convierta en costumbre, para que otros emprendedores como nosotros, desarrollen formas de reciclaje y protección al Medio Ambiente.", align: :justify, color: "959595"
      move_down 15
      text "EL AVU recolectado lo enviamos a reciclaje para la producción de un biocombustible amigable con el ambiente, denominado biodiesel. El biodiesel que producimos, disminuye la producción de emisiones de CO2 y otros gases de efecto invernadero (GEI), principales causantes del Calentamiento Global, hasta en un 90%, con respecto al diesel de petróleo. Obviamente nosotros solos no vamos a detener el Cambio Climático, pero tenemos la oportunidad, junto con ustedes, de contribuir definitoriamente, con los medios a nuestro alcance. Considere también el beneficio ambiental de atenuar la contaminación de cuerpos de agua y suelos; evitar daños por acumulación de grasas y aceites en el sistema hidráulico; evitar enfermedades asociadas con la venta de segunda mano de Aceite Vegetal Usado; así como, eliminar una fuente de alimento para la fauna nociva.", align: :justify, color: "959595"
      move_down 15
      text "Le informo que durante el año <b>#{@year}</b> recolectamos la siguiente cantidad de Litros de Aceite Vegetal Usado en nuestra visita a su establecimiento.", inline_format: true, align: :justify, color: "959595"
      move_down 15
      chart data, colors: %w(547C46), labels: [true]
      move_down 15
      text "Agradeciendo su atención, le envió un cordial saludo.", style: :bold, color: "959595"  
    end
  end

  def signature
    move_down 20
    text "Atentamente", color: "959595"
    image "#{Rails.root}/app/assets/images/firma.png"
    move_down 5
    text "Ing. Huguette Hernández Gómez", size: 10, color: "959595"
    text "Coordinadora General Quintana Roo", size: 10, color: "959595"
  end

  def footer
    move_down 20
    text "www.ugasa.mx / Of. (998) 5001890 / Av. Acanceh SM. 11 Plaza Terraviva Piso 3", style: :bold, color: "547C46", size: 10
  end
end