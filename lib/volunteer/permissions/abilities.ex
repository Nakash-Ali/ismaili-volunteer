defmodule Volunteer.Permissions.Abilities do
  alias Volunteer.Accounts.User
  alias Volunteer.Apply.Listing
  
  defmodule Admin do
    
    # Temporary super-user permissions

    def can?(
          %User{primary_email: primary_email},
          [:admin | _],
          _subject
        ) when primary_email in [
          "alizain.feerasta@iicanada.net",
          "hussein.kermally@iicanada.net",
        ] do
      true
    end
    
    # Listings

    def can?(
          %User{},
          [:admin, :listing, action | _],
          _
        ) when action in [:index, :create] do
      true
    end

    def can?(
          %User{id: user_id},
          [:admin, :listing, action | _],
          %Listing{created_by_id: user_id}
        ) when action in [:show, :update, :delete, :tkn_listing] do
      true
    end
    
    def can?(
          %User{id: user_id},
          [:admin, :listing, action | _],
          %Listing{organized_by_id: user_id}
        ) when action in [:show, :update, :delete, :tkn_listing] do
      true
    end
  end
  
  def can?(user, action) do
    can?(user, action, nil)
  end
  
  def can?(user, [:admin | _] = action, subject) do
    Admin.can?(user, action, subject)
  end
end
