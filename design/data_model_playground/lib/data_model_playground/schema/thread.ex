defmodule DataModelPlayground.Thread do
  use Ecto.Schema
  import Ecto.Changeset
  alias DataModelPlayground.{Repo, Category, Post, User}

  schema "threads" do
    import Ecto.Query
    belongs_to :category, Category
    has_many :posts, Post
    field :title, :string

    timestamps
  end

  @required_fields ~w(category_id title)a
  @optional_fields ~w()a

  def changeset(record, params \\ :empty) do
    record
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def user(thread) do
    thread =
      thread
      |> Repo.preload(posts: [:user])

    case thread.posts do
      [] -> {:error, "No first post"}
      [first_post|_] -> {:ok, first_post.user}
    end
  end
  def user(_) do
    {:error, "No first post!"}
  end
end
