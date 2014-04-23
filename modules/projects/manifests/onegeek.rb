class projects::onegeek {

  # Install Onegeek apps in ~/development/onegeek/*
  notify{ 'Including project "Onegeek"'}

  # boxen::project { 'trollin':
  #   dotenv        => true,
  #   elasticsearch => true,
  #   mysql         => true,
  #   nginx         => true,
  #   redis         => true,
  #   ruby          => '1.9.3',
  #   source        => 'boxen/trollin'
  # }
}