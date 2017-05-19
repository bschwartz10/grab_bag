class User::FoldersController < ApplicationController

  def show
    current_url = request.env["PATH_INFO"]
    username = current_url.split('/')[1]
    parent_slug= current_url.split('/')[-1]
    user = User.find_by(username: username)
    @current_folder = Folder.find_by(slug: parent_slug, user_id: user.id)
    session[:folder_id] = @current_folder.id
  end

  def index
  end

  def new
    @folder = Folder.new
  end

  def create
    parent_folder = Folder.find(session[:folder_id])

    new_route = parent_folder.route + "/" + folder_params[:name].parameterize

    folder = Folder.new(folder_params)
    folder.update(user_id: parent_folder.owner.id,
                  route: new_route,
                  folder_id: parent_folder.id,
                  slug: folder.slug)

    redirect_to folder.url, success: "Folder Successfully Created!"
  end


  private

  def folder_params

    params.require(:folder).permit(:name, :permission)

  end

end