class Lolita::I18nController < ApplicationController
  include Lolita::Controllers::UserHelpers
  before_filter :authenticate_lolita_user!, :set_current_locale

  layout "lolita/application"

  def index
    @translation_keys=Lolita::I18n.flatten_keys
  end

  def update
    respond_to do |format|
      format.json do
        render :nothing => true, :json => {error: !Lolita::I18n::Backend.set(params[:id],params[:translation])}
      end
    end
  end

  def translate_untranslated
    respond_to do |format|
      format.json do
        google_translate = Lolita::I18n::GoogleTranslate.new @active_locale
        google_translate.run
        render :nothing => true, :status => 200, :json => {errors: google_translate.errors, :translated => google_translate.untranslated}
      end
    end    
  end

  private

  def next_locale
    ::I18n::available_locales.collect{|locale| locale if locale != ::I18n.default_locale}.compact.first
  end

  def set_current_locale
    @active_locale = (params[:active_locale] || next_locale).to_sym
  end

end