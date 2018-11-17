defmodule VolunteerWeb.Services.TKNListingSpecGenerator do
  alias Volunteer.Commands.{Bash, Pandoc}
  alias VolunteerWeb.Presenters.Title
  alias VolunteerWeb.ListingView
  alias VolunteerWeb.Admin.TKNSpecView

  def static_at do
    Application.get_env(:volunteer, VolunteerWeb.Endpoint) |> Keyword.fetch!(:static_at)
  end

  def disk_dir() do
    Path.join([:code.priv_dir(:volunteer), static_at(), "tkn_listing_spec"])
  end

  def generate!(listing, tkn_listing) do
    spec_hash =
      generate_spec_hash(listing, tkn_listing)

    spec_dir =
      Path.join(disk_dir(), spec_hash)

    spec_filename =
      "#{spec_hash}.odt"

    spec_path =
      Path.join(disk_dir(), spec_filename)

    case File.stat(spec_path) do
      {:ok, %File.Stat{type: :regular}} ->
        nil

      _ ->
        ensure_empty_dir!(spec_dir)

        generate_assigns(listing, tkn_listing)
        |> generate_content_xml()
        |> write_content_xml_to_disk!(spec_dir)

        write_odt_file!(spec_hash, spec_filename, spec_dir)

        nil
    end

    spec_path
  end

  def generate_content_xml(assigns) do
    TKNSpecView.render("2018-v1.content.xml", assigns)
  end

  def generate_assigns(listing, tkn_listing) do
    {:ok, generated_responsibilities} =
      Pandoc.html_to_opendocument(listing.responsibilities)

    {:ok, generated_qualifications} =
      Pandoc.html_to_opendocument(listing.qualifications)

    %{
      country: "Canada",
      group: listing.group.title,
      program_title: listing.program_title,
      summary_line: listing.summary_line,
      organized_by_name: listing.organized_by.title,
      organized_by_email: listing.organized_by.primary_email,
      organized_by_phone: listing.organized_by.primary_phone,
      position_title: Title.text(listing),
      industry: tkn_listing.industry,
      function: tkn_listing.function,
      work_experience_level: tkn_listing.work_experience_level,
      education_level: tkn_listing.education_level,
      openings: tkn_listing.openings,
      start_date: ListingView.start_date_text(listing.start_date),
      end_date: ListingView.end_date_text(listing.end_date),
      commitment_type: tkn_listing.commitment_type,
      time_commitment: ListingView.time_commitment_text(listing),
      location_type: tkn_listing.location_type,
      search_scope: tkn_listing.search_scope,
      responsibilities: generated_responsibilities,
      qualifications: generated_qualifications,
      suggested_keywords: tkn_listing.suggested_keywords
    }
  end

  def generate_spec_hash(%{id: listing_id, updated_at: listing_updated_at}, %{updated_at: tkn_listing_updated_at}) do
    :sha
    |> :crypto.hash("#{listing_id}#{listing_updated_at}#{tkn_listing_updated_at}")
    |> Base.hex_encode32(case: :lower, padding: false)
  end

  def ensure_empty_dir!(dir) do
    {:ok, _files} = File.rm_rf(dir)
    :ok = File.mkdir_p(dir)
  end

  def write_content_xml_to_disk!(content_xml, spec_dir) do
    :ok =
      Path.join(spec_dir, "content.xml")
      |> File.write(content_xml, [:utf8])
  end

  def write_odt_file!(spec_hash, spec_filename, spec_dir) do
    {:ok, _, _} = Bash.run("ln -s ../base/* ./", spec_dir)
    {:ok, _, _} = Bash.run("zip -r #{spec_filename} #{spec_hash}", disk_dir())
  end
end
