# frozen_string_literal: true

module Decidim
  module Dpetitions
    # The data store for a Dpetition in the Decidim::Dpetitions component. It stores a
    # title, description and any other useful information to render a custom
    # dpetition.
    class Dpetition < Dpetitions::ApplicationRecord
      include Decidim::HasComponent
      include Decidim::HasCategory
      include Decidim::Resourceable
      include Decidim::Followable
      include Decidim::Comments::Commentable
      include Decidim::ScopableComponent
      include Decidim::Authorable
      include Decidim::Reportable
      include Decidim::HasReference
      include Decidim::Traceable
      include Decidim::Loggable
      include Decidim::DataPortability

      component_manifest_name "dpetitions"

      validates :title, presence: true

      def self.log_presenter_class_for(_log)
        Decidim::Dpetitions::AdminLog::DpetitionPresenter
      end

      # Public: Checks whether the dpetition is official or not.
      #
      # Returns a boolean.
      def official?
        author.blank?
      end

      # Public: Overrides the `reported_content_url` Reportable concern method.
      def reported_content_url
        ResourceLocatorPresenter.new(self).url
      end

      # Public: Calculates whether the current dpetition is an AMA-styled one or not.
      # AMA-styled dpetitions are those that have a start and end time set, and comments
      # are only open during that timelapse. AMA stands for Ask Me Anything, a type
      # of dpetition inspired by Reddit.
      #
      # Returns a Boolean.
      def ama?
        start_time.present? && end_time.present?
      end

      # Public: Checks whether the dpetition is an AMA-styled one and is open.
      #
      # Returns a boolean.
      def open_ama?
        ama? && Time.current.between?(start_time, end_time)
      end

      # Public: Checks if the dpetition is open or not.
      #
      # Returns a boolean.
      def open?
        (ama? && open_ama?) || !ama?
      end

      # Public: Overrides the `commentable?` Commentable concern method.
      def commentable?
        component.settings.comments_enabled?
      end

      # Public: Overrides the `accepts_new_comments?` Commentable concern method.
      def accepts_new_comments?
        return false unless open?
        commentable? && !comments_blocked?
      end

      # Public: Overrides the `comments_have_alignment?` Commentable concern method.
      def comments_have_alignment?
        true
      end

      # Public: Overrides the `comments_have_votes?` Commentable concern method.
      def comments_have_votes?
        true
      end

      # Public: Identifies the commentable type in the API.
      def commentable_type
        self.class.name
      end

      # Public: Overrides the `notifiable?` Notifiable concern method.
      def notifiable?(_context)
        false
      end

      # Public: Override Commentable concern method `users_to_notify_on_comment_created`
      def users_to_notify_on_comment_created
        return Decidim::User.where(id: followers).or(Decidim::User.where(id: component.participatory_space.admins)).distinct if official?
        followers
      end

      def self.export_serializer
        Decidim::Dpetitions::DataPortabilityDpetitionSerializer
      end

      private

      def comments_blocked?
        component.current_settings.comments_blocked
      end
    end
  end
end
