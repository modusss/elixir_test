defmodule Discuss.Topic do
  use Discuss.Web, :model

# we have to tell the model about how is the database we created to make possible phoenix to see it
  schema "topics" do
    field :title, :string
    belongs_to :user, Discuss.User
    has_many :comments, Discuss.Comment
  end
# struct:
# an hash that contains some data.
# represents a record (or a record we want to save) in the database

# params:
# A hash that containsthe properties we want to update the struct with

# changeset:
# knows the data we're trying to save and whether or not there a validations issues with it
# the '\\' makes a default value to be %{} if params are nil
  def changeset(struct, params \\ %{}) do
    struct
    # cast:
    # produces a changeset
    |> cast(params, [:title])
    # validators:
    # add errors to changeset
    |> validate_required([:title])
  end
end
