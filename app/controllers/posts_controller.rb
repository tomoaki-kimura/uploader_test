class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    image_data = Magick::Image.read(@post.photo.file.file)[0]
    #写真から緯度経度の中輸出
    exif_lat = image_data.get_exif_by_entry('GPSLatitude')[0][1].to_s.split(',').map(&:strip)
    exif_lng = image_data.get_exif_by_entry('GPSLongitude')[0][1].to_s.split(',').map(&:strip)
    @post.latitude = exif_lat.present? ? (Rational(exif_lat[0]) + Rational(exif_lat[1])/60 + Rational(exif_lat[2])/3600).to_f : nil
    @post.longitude = exif_lng.present? ? (Rational(exif_lng[0]) + Rational(exif_lng[1])/60 + Rational(exif_lng[2])/3600).to_f : nil
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:photo, :latitude, :longitude)
    end
end
