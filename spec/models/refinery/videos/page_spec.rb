require 'spec_helper'

module Refinery::Videos
  describe Page do
    it "can have videos added" do
      page = Factory(:page)
      page.videos.count.should eq(0)

      page.videos << Factory(:video)

      page.videos.count.should eq(1)
    end

    describe "#videos_attributes=" do
      it "adds videos" do
        page = Factory(:page)
        video = Factory(:video)

        page.videos.count.should == 0
        page.update_attributes({:videos_attributes => {"0" => {"id" => video.id}}})

        page.videos.count.should == 1
      end

      it "deletes specific videos" do
        page = Factory(:page)
        videos = [Factory(:video), Factory(:video)]
        page.videos = videos

        page.update_attributes(:videos_attributes => {
          "0" => {
            "id" => videos.first.id.to_s,
            "page_video_id" => page.page_videos.first.id,
          },
        })

        page.videos.should eq([videos.first])
      end

      it "deletes all videos" do
        page = Factory(:page)
        videos = [Factory(:video), Factory(:video)]
        page.videos = videos

       page.update_attributes(:videos_attributes => {"0" => {"id"=>""}})

        page.videos.should be_empty
      end

      it "reorders videos" do
        page = Factory(:page)
        videos = [Factory(:video), Factory(:video)]
        page.videos = videos

        page.update_attributes(:videos_attributes => {
          "0" => {
            "id" => videos.second.id,
            "page_video_id" => page.page_videos.second.id,
          },
          "1" => {
            "id" => videos.first.id,
            "page_video_id" => page.page_videos.first.id,
          },
        })

        page.videos.should eq([videos.second, videos.first])
      end
    end
  end
end
