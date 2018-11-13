# encoding: UTF-8
require "rubygems"
require "tmpdir"
require "bundler/setup"
require "jekyll"

# Change your GitHub reponame
GITHUB_REPONAME = "dixonmartinez/dixonmartinez.github.io"
GITHUB_REPO_BRANCH = "master"

SOURCE = "source/"
DEST = "_site"
CONFIG = {
  'layouts' => File.join(SOURCE, "_layouts"),
  'posts' => File.join(SOURCE, "_i18n/en/_posts"),
  'posts_es' => File.join(SOURCE, "_i18n/es/_posts"),
  'post_ext' => "md",
  'categories' => File.join(SOURCE, "categories"),
  'tags' => File.join(SOURCE, "tags"),
  'user' => "Dixon Martinez"
}

task default: %w[publish]

desc "Generate blog files"
task :generate do
  Jekyll::Site.new(Jekyll.configuration({
    "source"      => "source/",
    "destination" => "_site",
    "config"      => "_config.yml"
  })).process
end

desc "Generate and publish blog to gh-pages"
task :publish => [:generate] do
  Dir.mktmpdir do |tmp|
    cp_r "_site/.", tmp

    pwd = Dir.pwd
    Dir.chdir tmp

    system "git init"
    system "git checkout --orphan #{GITHUB_REPO_BRANCH}"
    system "git add ."
    message = "Site updated at #{Time.now.utc}"
    system "git commit -am #{message.inspect}"
    system "git remote add origin git@github.com:#{GITHUB_REPONAME}.git"
    system "git push origin #{GITHUB_REPO_BRANCH} --force"

    Dir.chdir pwd
  end
end


# usage rake new_post[my-new-post] or rake new_post['my new post'] 
# or rake new_post (defaults to "new-post")
desc "Begin a new post in #{CONFIG['posts']}"
task :new_post, :title do |t, args|
  abort("rake aborted: '#{CONFIG['posts']}' directory not found.") unless FileTest.directory?(CONFIG['posts'])
  args.with_defaults(:title => 'new-post')
  title = args.title;
  title = title.gsub(/\b\w/){$&.upcase} 

  tags = ""
  categories = ""

  # tags
  env_tags = ENV["tags"] || ""
  tags = strtag(env_tags)

  # categorias
  env_cat = ENV["category"] || ""
  categories = strtag(env_cat)

  # slug do post
  slug = mount_slug(title)

  begin
    date = (ENV['date'] ? Time.parse(ENV['date']) : Time.now).strftime('%Y-%m-%d')
    time = (ENV['date'] ? Time.parse(ENV['date']) : Time.now).strftime('%T')
  rescue => e
    puts "Error - date format must be YYYY-MM-DD, please check you typed it correctly!"
    exit -1
  end
  
  filename = File.join(CONFIG['posts'], "#{date}-#{slug}.#{CONFIG['post_ext']}")
  
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end

  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "author: #{CONFIG['user']}"
    post.puts "title: \"#{title.gsub(/-/,' ')}\""
    post.puts "permalink: #{slug}"
    post.puts "date: #{date} #{time}"
    post.puts "comments: true"
    post.puts "description: \"#{title}\""
    post.puts 'keywords: ""'
    post.puts "categories:"
    post.puts "#{categories}"
    post.puts "tags:"
    post.puts "#{tags}"
    post.puts "published: true"
    post.puts "---"
    post.puts
    post.puts
    post.puts
    post.puts "<!--more-->"

  end
end # task :new_post

# usage rake new_post[my-new-post] or rake new_post['my new post'] 
# or rake new_post (defaults to "new-post")
desc "Begin a new post in #{CONFIG['posts_es']}"
task :new_post_es, :title do |t, args|
  abort("rake aborted: '#{CONFIG['posts_es']}' directory not found.") unless FileTest.directory?(CONFIG['posts_es'])
  args.with_defaults(:title => 'nuevo-post')
  title = args.title;
  title = title.gsub(/\b\w/){$&.upcase} 
  
  tags = ""
  categories = ""

  # tags
  env_tags = ENV["tags"] || ""
  tags = strtag(env_tags)


  # categorias
  env_cat = ENV["category"] || ""
  categories = strtag(env_cat)

  # slug do post
  slug = mount_slug(title)

  begin
    date = (ENV['date'] ? Time.parse(ENV['date']) : Time.now).strftime('%Y-%m-%d')
    time = (ENV['date'] ? Time.parse(ENV['date']) : Time.now).strftime('%T')
  rescue => e
    puts "Error - date format must be YYYY-MM-DD, please check you typed it correctly!"
    exit -1
  end

  filename = File.join(CONFIG['posts_es'], "#{date}-#{slug}.#{CONFIG['post_ext']}")
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end

  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "author: #{CONFIG['user']}"
    post.puts "title: \"#{title.gsub(/-/,' ')}\""
    post.puts "permalink: #{slug}"
    post.puts "date: #{date} #{time}"
    post.puts "comments: true"
    post.puts "description: \"#{title}\""
    post.puts 'keywords: ""'
    post.puts "categories:"
    post.puts "#{categories}"
    post.puts "tags:"
    post.puts "#{tags}"
    post.puts "published: true"
    post.puts "---"
    post.puts
    post.puts
    post.puts
    post.puts "<!--more-->"

  end
end # task :new_post_es


desc "Create a new page."
task :page do
  name = ENV["name"] || "new-page.md"
  filename = File.join(SOURCE, "#{name}")
  filename = File.join(filename, "index.html") if File.extname(filename) == ""
  title = File.basename(filename, File.extname(filename)).gsub(/[\W\_]/, " ").gsub(/\b\w/){$&.upcase}
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end

  slug = mount_slug(title)

  mkdir_p File.dirname(filename)
  puts "Creating new page: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: page"
    post.puts "title: \"#{title}\""
    post.puts 'description: ""'
    post.puts 'keywords: ""'
    post.puts "permalink: \"#{slug}\""
    post.puts "slug: \"#{slug}\""
    post.puts "---"
    post.puts "{% include JB/setup %}"
  end
end # task :page

def mount_slug(title)
  slug = str_clean(title)
  slug = slug.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

  return slug
end

def str_clean(title)
  return title.tr("À�?ÂÃÄÅàáâãäåĀ�?ĂăĄąÇçĆćĈĉĊċČ�?�?ðĎ�?�?đÈÉÊËèéêëĒēĔĕĖėĘęĚěĜ�?ĞğĠġĢģĤĥĦħÌ�?Î�?ìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀ�?łÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌ�?Ŏ�?�?őŔŕŖŗŘřŚśŜ�?ŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵ�?ýÿŶŷŸŹźŻżŽž", "AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz")
end

def strtag(str_tags)
  tags = "";

  if !str_tags.nil?
    arr_tags = str_tags.split(",")
    arr_tags.each do |t|
      tags = tags + "- " + t.delete(' ') + "\n"
    end
  end

  return tags
end

def ask(message, valid_options)
    if valid_options
        answer = get_stdin("#{message} #{valid_options.to_s.gsub(/"/, '').gsub(/, /,'/')} ") while !valid_options.include?(answer)
    else
        answer = get_stdin(message)
    end
    answer
end

def get_stdin(message)
    print message
    STDIN.gets.chomp
end

desc "Execute Jekyll Serve in windows"
task :runwindows do
    puts '* Changing the codepage'
    `chcp 65001`
    puts '* Running Jekyll'
    `bundle exec jekyll serve --watch --drafts`
end
